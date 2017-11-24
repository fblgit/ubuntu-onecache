# ubuntu-onecache
Ubuntu Binary and Docker of OneCache 

OneCache is a Redis Transparent Sharding/Cluster Proxy written in C with a very high IOPS

1, Multiple threads model provide higher performance for single instance, even without pipeline feature, less proxy instances make operation easy.

2, Server group supported, you can group redis master & slave together for load balance and failover to prevent key remap of the hash range in case of one node failure. Different load balance policies are supported.

3, You move some hot keys to different redis instance in case that there are too much hot keys in a single instance by key based map rules.

4, Cross node operation support including "mget", "mset" etc.

5, Unix socket connection enabled.

6, Real time performance statistics, including top keys statistics.

7, Daemon process protect you from proxy instance failure.

8, Virtual IP based HA feature protect you from proxy host failure.

# server.xml Example
<onecache port="8221" thread_num="15" hash_value_max="80" daemonize="0" guard="0" log_file="" password="" pid_file="" hash=" fnv1a_64" twemproxy_mode="0" debug="0">
    <!--port Listening Port-->
    <!--thread_num Numbers of Threads-->
    <!--hash_value_max Sharding Hash Max Value (Max:1024)-->
    <!--daemonize 1=YES 0=NO-->
    <!--guard Guard Daemon Enabled 1=YES 0=NO-->
    <!--log_file LogFile Path-->
    <!--password To Access the OneCache Listener from clients-->
    <!--pid_file pid-file path -->
    <!--hash hash algorythm -->
    <!--twemproxy_mode 0 to disable, valid: ketama, groupname servername-->
    <!--debug 0/1 enabled disable debug-->

    <vip if_alias_name="eth0:0" vip_address="172.30.12.8" enable="0"></vip>
    <! -- VIP  Configuration, if_alias_name interface vip_address ip address enable 0/1 -->

    <top_key enable=" 0"></top_key>
    <!--Enable or Disable top_key 0/1-->

    <group_option backend_retry_interval="3" backend_retry_limit="10" auto_eject_group="1" group_retry_time="30" eject_after_restore="1"></group_option>
    <!--backend_retry_interval Backend Retry Interval -->
    <!--backend_retry_limit Retry Limit -->
    <!--auto_eject_group 1=YES 0=NO-->
    <!--group_retry_time Group Retry Time-->
    <!--eject_after_restore 1=YES 0=NO-->
    
    <!-- Group 1 Example Master/Slave replica, hashing from 0 to 19 -->
    <group name="group1" hash_min="0" hash_max="19" policy="master_only">
        <host host_name="host1" ip="172.30.12.12" port="6379" master="1" password="" connection_num="50"></host>
        <host host_name="host1" ip="172.30.12.12" port="6380" master="0" password="" connection_num="50"></host>
	<!--connect_num maximum connections to redis backend-->
    </group>
    <group name="group2" hash_min="20" hash_max="39">
        <host host_name="host1" ip="172.30.12.12" port="6381" master="1"></host>
    </group>
    <group name="group3" hash_min="40" hash_max="59">
        <host host_name="host1" ip="172.30.12.12" port="6382" master="1"></host>
    </group>
    <group name="group4" hash_min="60" hash_max="79">
        <host host_name="host1" ip="172.30.12.12" port="6383" master="1"></host>
    </group>

    <!-- Hash Mapping based on Value -->
    <hash_mapping>
        <hash value="0" group_name="group1"></hash>
        <hash value="1" group_name="group1"></hash>
    </hash_mapping>
    <!--Key Mapping based on Key Name -->
    <key_mapping>
        <key key_name="key1" group_name="group1"></key>
        <key key_name="key2" group_name="group2"></key>
    </key_mapping>
</onecache>
