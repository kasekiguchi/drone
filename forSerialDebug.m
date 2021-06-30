
for i = 0:10:1000
   agent.plant.connector.sendData(gen_msg([i 500 0 500 500 0 0 0]))
   pause(0.1)
end