#!/sbin/sh
# BlueOS mojito recovery diagnostic only.
# Read-only: does not mount, format, erase, or write device partitions.

OUT="/tmp/blueos-recovery-report.txt"

{
  echo "BlueOS recovery diagnostic"
  echo "=========================="
  echo "Date: $(date 2>/dev/null)"
  echo
  echo "[Recovery / device properties]"
  for key in ro.twrp.version ro.product.device ro.product.name ro.boot.slot_suffix ro.boot.dynamic_partitions ro.boot.hardware ro.build.version.release; do
    printf "%s=%s\n" "$key" "$(getprop "$key" 2>/dev/null)"
  done
  echo
  echo "[Block devices by-name]"
  if [ -d /dev/block/by-name ]; then
    ls -l /dev/block/by-name 2>&1
  else
    echo "/dev/block/by-name is missing"
  fi
  echo
  echo "[Logical mapper devices]"
  if [ -d /dev/block/mapper ]; then
    ls -l /dev/block/mapper 2>&1
  else
    echo "/dev/block/mapper is missing"
  fi
  echo
  echo "[Available inspection tools]"
  for tool in lpdump lpunpack sgdisk parted blockdev; do
    if command -v "$tool" >/dev/null 2>&1; then
      printf "%s: %s\n" "$tool" "$(command -v "$tool")"
    else
      printf "%s: not found\n" "$tool"
    fi
  done
  echo
  echo "END OF REPORT"
} > "$OUT" 2>&1

cat "$OUT"
echo
echo "Saved diagnostic report to $OUT"
echo "This diagnostic does not install BlueOS."
exit 0
