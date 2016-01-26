require 'net/http'
require 'json'

require 'usagewatch'

usw = Usagewatch

uri = URI('http://ec2-52-77-228-92.ap-southeast-1.compute.amazonaws.com/api/v1/status')

req = Net::HTTP::Post.new(uri)
req['Authorization'] = "Token token=this is a token"

instance_id = (`ec2metadata --instance-id` rescue `ec2-metadata -i`).split(' ').last.chomp
cpu = usw.uw_cpuused
disk = usw.uw_diskused_perc
processes = usw.uw_cputop
params = {data: { time: Time.now, cpu: cpu, disk: disk, processes: processes, instance_id: instance_id }.to_json}

req.set_form_data({data: {time: Time.now, cpu: (rand*100).to_i, memory:
                          (rand*100).to_i, instance_id: (rand*100000000).to_i}.to_json})
req.set_form_data(params)

res = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(req)
end

p res.code
