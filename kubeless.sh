curl --data 'HOSTNAME' \
  --header "Host: get-go.192.168.29.165.nip.io" \
  --header "Content-Type:application/json" \
  192.168.29.165

  kubeless function deploy get-go --runtime go1.13 --handler test.Foo --from-file test.go --dryrun -o yaml 

  kubeless trigger http create get-go --function-name get-go


https://github.com/kubeless/kubeless/blob/master/docs/runtimes.md
