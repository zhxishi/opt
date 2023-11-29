for i in `ls -lrd /home/enjoymi/sgzj2_android2_{526..540}  | awk -F ' ' '{print $9}'`; 
do 
# 新增watchcenter服
#    cp -a ${i}/prod_sgzj_server/settings/server_config.xml ${i}/prod_sgzj_server/settings/server_config.xml_20210525; 
    sed -i '/^<watchcenter/d'  ${i}/prod_sgzj_server/settings/server_config.xml;
    sed -i '/host_in="0"/d'  ${i}/prod_sgzj_server/settings/server_config.xml; 
    sed -i '/gate_host="0"/d'  ${i}/prod_sgzj_server/settings/server_config.xml;
    sed -i '/collector_host="0"/d'  ${i}/prod_sgzj_server/settings/server_config.xml;
    sed -i '/sync_host="0"/d'  ${i}/prod_sgzj_server/settings/server_config.xml;
    sed -i '/battle_host="106.75.176.103"/d' ${i}/prod_sgzj_server/settings/server_config.xml;
#    sed -i '/^<lobbydb/a <raiddb host="127.0.0.1" port="3306" name="sgzj2_ios2_1_raid" user="root" password=""/>' ${i}/prod_sgzj_server/settings/server_config.xml;
    sed -i '/^<matchserver/i  <watchcenter client_host="0" client_port="0"\n            host_in="0" port_in="0" host_out="0" port_out="0"\n            gate_host="0" gate_port="0"\n            collector_host="0" collector_port="0"\n            battle_host="122.112.201.209" battle_port="20705"\n            sync_host="0" sync_port="0"/>\n' ${i}/prod_sgzj_server/settings/server_config.xml; 
done
