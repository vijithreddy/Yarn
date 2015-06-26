
#!/bin/sh


# Verify this path corresponds to your installation
HADOOP_PATH=/opt/cloudera/parcels/CDH/lib/hadoop-0.20-mapreduce

# Mapper containers
for i in 2 4 8
do
   # Reducer containers
   for j in 2 4 8
   do
      # Container memory
      for k in 512 1024
      do
         # JVM heap for mappers
         MAP_MB=`echo "($k*0.8)/1" | bc`

         # JVM heap for reducers
         RED_MB=`echo "($k*0.8)/1" | bc`


       # Teragen, change the paths here
        hadoop jar $HADOOP_PATH/hadoop-examples.jar teragen -Dmapreduce.job.maps=$i -Dmapreduce.map.memory.mb=$k -Dmapreduce.map.java.opts.max.heap=$MAP_MB 100000000 /results/tg-10GB-${i}-${j}-${k} 1>/root/tera/tera_${i}_${j}_${k}.out 2>/root/tera/tera_${i}_${j}_${k}.err
        #Terasort, change the paths here
        hadoop jar $HADOOP_PATH/hadoop-examples.jar terasort  -Dmapreduce.job.maps=$i -Dmapreduce.job.reduces=$j -Dmapreduce.map.memory.mb=$k -Dmapreduce.map.java.opts.max.heap=$MAP_MB -Dmapreduce.reduce.memory.mb=$k  -Dmapreduce.reduce.java.opts.max.heap=$RED_MB /results/tg-10GB-${i}-${j}-${k} /results/ts-10GB-${i}-${j}-${k}  1>>/root/tera/tera_${i}_${j}_${k}.out 2>>/root/tera/tera_${i}_${j}_${k}.err     


         hadoop fs -rm -r -skipTrash /results/tg-10GB-${i}-${j}-${k}
         hadoop fs -rm -r -skipTrash /results/ts-10GB-${i}-${j}-${k}
      done
   done
done
