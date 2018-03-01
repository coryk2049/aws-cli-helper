source $AWS_HELPER_HOME/bin/aws_utils.sh
list_ec2="aws ec2 describe-instances"
list_ec2_len=$(resource_len "$list_ec2")
ecs_instances=$($list_ec2 --output json)
for ((i=0; i < "$list_ec2_len"; i++)); do
	ecs_instance=$(query "$ecs_instances" Reservations[$i])
	InstanceId=$(query "$ecs_instance" Instances[0].InstanceId)
	InstanceType=$(query "$ecs_instance" Instances[0].InstanceType)
	LaunchTime=$(query "$ecs_instance" Instances[0].LaunchTime)
	ImageId=$(query "$ecs_instance" Instances[0].ImageId)
	VirtualizationType=$(query "$ecs_instance" Instances[0].VirtualizationType)
	VpcId=$(query "$ecs_instance" Instances[0].VpcId)
	SubnetId=$(query "$ecs_instance" Instances[0].SubnetId)
	KeyName=$(query "$ecs_instance" Instances[0].KeyName)
	PublicDnsName=$(query "$ecs_instance" Instances[0].PublicDnsName)
	PublicIpAddress=$(query "$ecs_instance" Instances[0].PublicIpAddress)
	PrivateDnsName=$(query "$ecs_instance" Instances[0].PrivateDnsName)
	PrivateIpAddress=$(query "$ecs_instance" Instances[0].PrivateIpAddress)
	StateCode=$(query "$ecs_instance" Instances[0].State.Code)
	StateName=$(query "$ecs_instance" Instances[0].State.Name)
	info "InstanceId: $InstanceId"
	info "InstanceType: $InstanceType"
	info "LaunchTime: $LaunchTime"
	info "ImageId: $ImageId"
	info "VirtualizationType: $VirtualizationType"
	info "VpcId: $VpcId"
	info "SubnetId: $SubnetId"
	info "KeyName: $KeyName"
	info "PublicIpAddress: $PublicIpAddress"
	info "PublicDnsName: $PublicDnsName"
	info "PrivateIpAddress: $PrivateIpAddress"
	info "PrivateDnsName: $PrivateDnsName"
	info "StateCode: $StateCode"
	info "StateName: $StateName"
	breaker_by_index $i
done
