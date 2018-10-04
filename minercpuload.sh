#!/bin/bash

miner_screen_name="MINER" # set this to your own screen name. if you don't have one, make one with: screen -S MINER
miner_server_port="3335"

if [[ ! $(uname -r | cut -d '-' -f3) == Microsoft ]]; then

	while true; do
	cpu_usage=$(echo $((100-$(vmstat 1 2|tail -1|awk '{print $15}'))))

		if [[ $cpu_usage -le 25  ]]; then
			echo "Low_CPU_usage_detected: $cpu_usage%"
			echo "Sending CTRL+C..." && screen -S $miner_screen_name -p 0 -X stuff "^C" && sleep 2
			echo "Starting npm run commands..." && screen -S $miner_screen_name -p 0 -X stuff "SERVER_PORT=$miner_server_port npm run commands^M" && sleep 2

			while :; do
			cmd_pool=$(screen -x $miner_screen_name -X hardcopy /tmp/cmd_pool && cat /tmp/cmd_pool | grep Command: | tail -n 1)
				if [[ -z $cmd_pool ]]; then echo "Waiting for [Command:]..." && sleep 1; else echo "Sending command 10..." && screen -S $miner_screen_name -p 0 -X stuff "10^M"; break; fi
			done

			while :; do
			select_pool=$(screen -x $miner_screen_name -X hardcopy /tmp/select_pool && cat /tmp/select_pool | grep y/n | tail -n 1)
				if [[ -z $select_pool ]]; then echo "Waiting for [y/n]..." && sleep 1; else echo "Confirming pool selection [y]..." && screen -S $miner_screen_name -p 0 -X stuff "y^M" && echo "Miner started!" && rm /tmp/cmd_pool && rm /tmp/select_pool; break; fi
			done
		else
			echo "CPU usage is: $cpu_usage%"
		fi
		sleep 60
	done

elif [[ $(uname -r | cut -d '-' -f3) == Microsoft ]]; then # Windows 10 Ubuntu Subsystem

	while true; do
	cpu_usage=$(echo "$(top -d2 -n2 | awk '/^%Cpu/{printf "%.0f\n", $2}' | awk 'NR==2{print $1}')")

		if [[ $cpu_usage -le 25  ]]; then
			echo "Low_CPU_usage_detected: $cpu_usage%"
			echo "Sending CTRL+C..." && screen -S $miner_screen_name -p 0 -X stuff "^C" && sleep 2
			echo "Starting npm run commands..." && screen -S $miner_screen_name -p 0 -X stuff "SERVER_PORT=$miner_server_port npm run commands^M" && sleep 2

			while :; do
			cmd_pool=$(screen -x $miner_screen_name -X hardcopy /tmp/cmd_pool && cat /tmp/cmd_pool | grep Command: | tail -n 1)
				if [[ -z $cmd_pool ]]; then echo "Waiting for [Command:]..." && sleep 1; else echo "Sending command 10..." && screen -S $miner_screen_name -p 0 -X stuff "10^M"; break; fi
			done

			while :; do
			select_pool=$(screen -x $miner_screen_name -X hardcopy /tmp/select_pool && cat /tmp/select_pool | grep y/n | tail -n 1)
				if [[ -z $select_pool ]]; then echo "Waiting for [y/n]..." && sleep 1; else echo "Confirming pool selection [y]..." && screen -S $miner_screen_name -p 0 -X stuff "y^M" && echo "Miner started!" && rm /tmp/cmd_pool && rm /tmp/select_pool; break; fi
			done
		else
			echo "CPU usage is: $cpu_usage%"
		fi
		sleep 60
	done
fi
