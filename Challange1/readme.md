3 Tier Structure -

Web layer 
AppLayer
DB Layer

Web layer consists 2 VMs in an availabilty Set is behind public facing ApplicationGateway with waf and SSL, 
AppLayer consist 2 Vms in an availability Set is behind internal load balancer and communication between AppLayer and webLayer through Loadbalance Frontend
DBlayer consists 2 Vms in an availability set is behind internal load balancer and load balancer's frontend can act as SQL always On ClusterIP.
					