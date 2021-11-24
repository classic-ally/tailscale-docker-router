#!/bin/bash
targets=$(printenv | grep custom_)
sleep 5s

while IFS= read -r line; do
	tmp=$(awk -F= '{print $2}' <<< $line)
	target_host=$(awk -F: '{print $1}' <<< $tmp)
	target_port=$(awk -F: '{print $2}' <<< $tmp)
	iptables -t nat -A PREROUTING -d $(ifconfig tailscale0 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1) -p tcp --dport $target_port -j DNAT --to-dest $(getent hosts $target_host | awk '{ print $1 }'):$target_port
	iptables -t nat -A POSTROUTING -d $(getent hosts $target_host | awk '{ print $1 }') -p tcp --dport $target_port -j SNAT --to-source $(ifconfig $(route | grep default | awk '{print $8}') | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)
	iptables -t nat -A PREROUTING -d $(ifconfig tailscale0 | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1) -p udp --dport $target_port -j DNAT --to-dest $(getent hosts $target_host | awk '{ print $1 }'):$target_port
	iptables -t nat -A POSTROUTING -d $(getent hosts $target_host | awk '{ print $1 }') -p udp --dport $target_port -j SNAT --to-source $(ifconfig $(route | grep default | awk '{print $8}') | grep 'inet addr:' | cut -d: -f2| cut -d' ' -f1)
done <<< "$targets"

