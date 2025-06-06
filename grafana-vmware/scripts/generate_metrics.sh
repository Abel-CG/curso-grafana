#!/bin/bash

OUT="/textfile_collector/vcenter_sim.prom"
CLUSTERS=(vcenter-cluster-1 vcenter-cluster-2)
HOSTS=(esxi1 esxi2 esxi3 esxi4 esxi5 esxi6 esxi7)
VMS=(vm01 vm02 vm03 vm04 vm05 vm06 vm07 vm08 vm09 vm10 vm11 vm12 vm13 vm14 vm15 vm16 vm17 vm18 vm19 vm20 vm21 vm22 vm23 vm24 vm25 vm26 vm27 vm28 vm29 vm30)
DS=(DS1 DS2 DS3)

CLUSTER_NAME=${CLUSTERS[$RANDOM % ${#CLUSTERS[@]}]}

while true; do

echo "# HELP vcenter_simulated_metrics Simulated vCenter metrics" > $OUT
echo "# TYPE vcenter_simulated_metrics gauge" >> $OUT

# Host metrics
for h in "${HOSTS[@]}"; do
  STATUS=$(shuf -n1 -e up maintenance down)
  VALUE=$([ "$STATUS" = "up" ] && echo 1 || echo 0)
  echo "vcenter_host_status{cluster=\"$CLUSTER_NAME\",host=\"$h\",status=\"$STATUS\"} $VALUE" >> $OUT
done

# VM metrics
for vm in "${VMS[@]}"; do
  CPU=$(awk -v min=10 -v max=90 'BEGIN{srand(); print min+rand()*(max-min)}')
  MEM=$(shuf -i 1024-8192 -n1)
  TX=$(shuf -i 10000000-500000000 -n1)
  POWER=$(shuf -n1 -e on off)
  HOST=${HOSTS[$RANDOM % ${#HOSTS[@]}]}
  echo "vcenter_vm_cpu_usage_percent{cluster=\"$CLUSTER_NAME\",host=\"$HOST\",vm=\"$vm\"} $CPU" >> $OUT
  echo "vcenter_vm_mem_used_mb{cluster=\"$CLUSTER_NAME\",host=\"$HOST\",vm=\"$vm\"} $MEM" >> $OUT
  echo "vcenter_vm_network_tx_bytes_total{cluster=\"$CLUSTER_NAME\",host=\"$HOST\",vm=\"$vm\"} $TX" >> $OUT
  echo "vcenter_vm_power_state{cluster=\"$CLUSTER_NAME\",host=\"$HOST\",vm=\"$vm\",state=\"$POWER\"} $([ "$POWER" = "on" ] && echo 1 || echo 0)" >> $OUT

  # Disk metrics
  DS=${DS[$RANDOM % ${#DS[@]}]}
  DISK_SIZE=$(shuf -i 20-500 -n1)
  DISK_USED=$(shuf -i 1-$DISK_SIZE -n1)
  echo "vcenter_vm_disk_total_gb{cluster=\"$CLUSTER_NAME\",host=\"$HOST\",vm=\"$vm\",datastore=\"$DS\"} $DISK_SIZE" >> $OUT
  echo "vcenter_vm_disk_used_gb{cluster=\"$CLUSTER_NAME\",host=\"$HOST\",vm=\"$vm\",datastore=\"$DS\"} $DISK_USED" >> $OUT
done

# Datastore metrics
for ds in "${DS[@]}"; do
  SPACE=$(awk -v min=100 -v max=800 'BEGIN{srand(); printf "%.1f\n", min+rand()*(max-min)}')
  echo "vcenter_datastore_free_gb{cluster=\"$CLUSTER_NAME\",datastore=\"$ds\"} $SPACE" >> $OUT
done

  sleep 2
done
