# WebDollar Miner CPU Load
Make your miner keep its CPU load automatically to avoid hashrate drops

#### 1. Open your miner in a screen: 
```shell
screen -S MINER
cd Node-WebDollar
npm run commands 
10 # start mining in a pool
``` 
now hit 
```
ctrl a then d # to detach from Screen
```
#### 2. Start ```bash minercpuload.sh``` from any location!

### Info
#### Script checks CPU load every 60 seconds - if CPU load is below or equal to 25%, WebDollar Miner will be restarted.

