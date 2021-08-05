#!/usr/bin/env python3
import os
import subprocess
from common.spinner import Spinner

if __name__ == "__main__":
  import time
  with Spinner() as s:
    s.update("building legacy capnproto")
    subprocess.run(["/data/openpilot/scripts/install_old_capnp.sh"])

