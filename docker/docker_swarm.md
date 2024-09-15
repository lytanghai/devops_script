Requirements:
- Hosts (2+): Docker Installed
- Design one of the hosts must be a swarm manager or master and other are slaves or workers
- Run { $docker swarm init } on swarm manager node
- Copy the command from the swarm init and paste it into worker nodes to join
- Done 


 + Encourage:
- Have more than one manager node in a single cluster to prevent fault tolerant
- Have one than one manager nodes will be lead to conflict of interest. Solution is to make one of the manager node to handle the manager decision (leader). *It does not mean that the leader can decide on its own, it must be agree by the majority of managers in the cluster.
- Recommended by Docker to have only 7 managers at most.
- Manager nodes should be in odd number: 3,5,7
- If all the nodes master failed at the same time, the worker node still perform its operation as normal but it could not receieve any modification or getting new nodes. Solution: try to bring at least one master node back to normal. If one of the 3 master nodes, and 2 are failed to bring online, the only way to recover is to force create new cluster. { $ docker swarm init --force--new--cluster} on node manager that could online (only 1 of 3)
- To promote worker into master, ${$docker node promote }
- Master node can also work as a normal node such as hosting web by default. We can also disable it to only make it handle management tasks only with cmd {$docker node update --availability drain <Node>}.
