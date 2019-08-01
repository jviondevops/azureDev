set -x
az login -u partha.chatterjee@jvion.com -p Stepover@17
terraform init
terraform state list >> test.txt
while IFS= read -r line; do
    echo "Text read from file: $line"
    terraform state rm $line
done < "test.txt"
terraform apply -var="suffix=ned_stark" -var="resource_group_name=data-science-rg" -var="virtual_net=data-science-vnet" -var="subnet=virtual-machines" -auto-approve
