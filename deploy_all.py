#!/usr/bin/env python3
"""
deploy_all.py
Master deployment script for all DuckDB sample databases:
- AdventureWorks Data Warehouse (adventureworks_dw)
- AdventureWorks OLTP (adventureworks_oltp)
- DVD Rental (dvdrental)
- FSI Demo (fsi_demo)

Usage:
    python deploy_all.py
    python deploy_all.py --databases dvdrental,fsi_demo
"""
import argparse
import importlib.util
import os
import shutil
import sys
import time

DATABASES = {
    "adventureworks_dw": {
        "display_name": "AdventureWorks Data Warehouse",
        "folder": "adventureworks_dw",
        "output_file": "adventureworks_dw.duckdb",
    },
    "adventureworks_oltp": {
        "display_name": "AdventureWorks OLTP",
        "folder": "adventureworks_oltp",
        "output_file": "adventureworks_oltp.duckdb",
    },
    "dvdrental": {
        "display_name": "DVD Rental (PostgreSQL)",
        "folder": "dvdrental",
        "output_file": "dvdrental.duckdb",
    },
    "fsi_demo": {
        "display_name": "FSI Demo (Financial Services)",
        "folder": "fsi_demo",
        "output_file": "fsi_demo.duckdb",
    },
}


def deploy_all(selected_dbs=None):
    script_dir = os.path.dirname(os.path.abspath(__file__))

    if not selected_dbs or selected_dbs.lower() == "all":
        target_keys = list(DATABASES.keys())
    else:
        target_keys = [k.strip().lower() for k in selected_dbs.split(",")]
        for k in target_keys:
            if k not in DATABASES:
                print(f"[ERROR] Unknown database: '{k}'")
                print(f"Available databases: {', '.join(DATABASES.keys())}")
                return 1

    print("\n" + "=" * 70)
    print("           DuckDB Sample Databases - Master Deployer            ")
    print("=" * 70)
    print("\nDatabases to build:")
    for k in target_keys:
        print(f"  - {DATABASES[k]['display_name']} ({DATABASES[k]['output_file']})")
    print("\n" + "=" * 70)

    results = {}
    master_start = time.time()

    for k in target_keys:
        info = DATABASES[k]
        db_folder = os.path.join(script_dir, info["folder"])
        build_script = os.path.join(db_folder, "build.py")

        print("\n" + "-" * 70)
        print(f"  Deploying: {info['display_name']}")
        print("-" * 70)

        if not os.path.exists(build_script):
            results[k] = {"status": "SKIPPED", "duration": "-", "size": "-"}
            print(f"[WARN] Build script not found: {build_script}")
            continue

        db_start = time.time()
        try:
            if db_folder not in sys.path:
                sys.path.insert(0, db_folder)

            # Import or reload build module
            mod_name = f"{info['folder']}_build"
            spec = importlib.util.spec_from_file_location(mod_name, build_script)
            mod = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(mod)

            exit_code = mod.build_database()
            duration_sec = time.time() - db_start
            duration_str = f"{int(duration_sec // 60):02d}:{int(duration_sec % 60):02d}"

            out_db = os.path.join(db_folder, info["output_file"])
            if exit_code == 0 and os.path.exists(out_db):
                size_mb = os.path.getsize(out_db) / (1024 * 1024)
                # Copy to repository root for convenient top-level access
                root_copy = os.path.join(script_dir, info["output_file"])
                try:
                    shutil.copy2(out_db, root_copy)
                except Exception:
                    pass

                # Also copy companion aliases to root if present
                for alias in ["adventureworks.duckdb", "sei_demo.duckdb"]:
                    alias_src = os.path.join(db_folder, alias)
                    if os.path.exists(alias_src):
                        try:
                            shutil.copy2(alias_src, os.path.join(script_dir, alias))
                        except Exception:
                            pass

                results[k] = {
                    "status": "SUCCESS",
                    "duration": duration_str,
                    "size": f"{size_mb:.2f} MB",
                }
            else:
                results[k] = {
                    "status": "FAILED",
                    "duration": duration_str,
                    "size": "-",
                }
        except Exception as e:
            duration_sec = time.time() - db_start
            duration_str = f"{int(duration_sec // 60):02d}:{int(duration_sec % 60):02d}"
            results[k] = {
                "status": "ERROR",
                "duration": duration_str,
                "size": "-",
                "error": str(e),
            }
            print(f"[ERROR] Failed deploying {info['display_name']}: {e}")

    # Summary Table
    total_elapsed = time.time() - master_start
    total_str = f"{int(total_elapsed // 60):02d}:{int(total_elapsed % 60):02d}"
    success_cnt = sum(1 for r in results.values() if r["status"] == "SUCCESS")
    failed_cnt = sum(1 for r in results.values() if r["status"] in ("FAILED", "ERROR"))
    skipped_cnt = sum(1 for r in results.values() if r["status"] == "SKIPPED")

    print("\n" + "=" * 70)
    print("                       DEPLOYMENT SUMMARY                             ")
    print("=" * 70)
    print(f"  {'Database':<34} {'Status':<12} {'Duration':<10} {'Size':<10}")
    print("  " + "-" * 66)

    for k in target_keys:
        info = DATABASES[k]
        r = results[k]
        print(f"  {info['display_name']:<34} {r['status']:<12} {r['duration']:<10} {r['size']:<10}")

    print("  " + "-" * 66)
    print(f"  Total: {success_cnt} succeeded, {failed_cnt} failed, {skipped_cnt} skipped")
    print(f"  Total Duration: {total_str}")
    print("=" * 70 + "\n")

    if success_cnt > 0:
        print("  Database files built:")
        for k in target_keys:
            if results[k]["status"] == "SUCCESS":
                p = os.path.join(script_dir, DATABASES[k]["folder"], DATABASES[k]["output_file"])
                print(f"    - {p}")
        print("\n  Connect using Python:")
        print('    import duckdb')
        print('    conn = duckdb.connect("dvdrental/dvdrental.duckdb")\n')

    return 0 if failed_cnt == 0 else 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Master deployer for all DuckDB sample databases.")
    parser.add_argument(
        "--databases", "-d",
        help="Comma-separated list of databases to deploy (default: all)",
        default="all"
    )
    args = parser.parse_args()
    sys.exit(deploy_all(args.databases))
