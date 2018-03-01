source $AWS_HELPER_HOME/bin/aws_utils.sh
list_users="aws iam list-users"
list_users_len=$(resource_len "$list_users")
iam_users=$($list_users --output json)
for ((i=0; i < "$list_users_len"; i++)); do
	# User
	iam_user=$(query "$iam_users" Users[$i])
	UserName=$(query "$iam_user" UserName)
	UserArn=$(query "$iam_user" Arn)
	UserId=$(query "$iam_user" UserId)
	UserCreateDate=$(query "$iam_user" CreateDate)
	info "UserName: $UserName"
	info "UserId: $UserId"
	info "UserArn: $UserArn"
	info "UserCreateDate: $UserCreateDate"
	# Group
	list_groups_for_user="aws iam list-groups-for-user"
	list_groups_for_user_len=$(resource_len_by_user "$list_groups_for_user" $UserName)
	iam_groups=$($list_groups_for_user --user-name $UserName)
	for ((j=0; j < "$list_groups_for_user_len"; j++)); do
		iam_group=$(query "$iam_groups" Groups[$j])			
		GroupName=$(query "$iam_group" GroupName)
		GroupId=$(query "$iam_group" GroupId)
		GroupArn=$(query "$iam_group" Arn)
		GroupCreateDate=$(query "$iam_group" CreateDate)
		info "GroupName: $GroupName"		
		info "GroupId: $GroupId"	
		info "GroupArn: $GroupArn"	
		info "GroupCreateDate: $GroupCreateDate"			
	done
	# Attached Policy
	list_attached_user_policies="aws iam list-attached-user-policies"
	list_attached_user_policies_len=$(resource_len_by_user "$list_attached_user_policies" $UserName)
	attached_policies=$($list_attached_user_policies --user-name $UserName)
	for ((j=0; j < "$list_attached_user_policies_len"; j++)); do
		attached_policy=$(query "$attached_policies" AttachedPolicies[$j])
		PolicyName=$(query "$attached_policy" PolicyName)
		PolicyArn=$(query "$attached_policy" PolicyArn)
		info "PolicyName: $PolicyName"
		info "PolicyArn: $PolicyArn"
	done
	breaker
done
