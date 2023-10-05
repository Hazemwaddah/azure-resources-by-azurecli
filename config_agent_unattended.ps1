	
cd D:\$(AgentFolder)
.\config.cmd --unattended `
  --url $(AgentOrg) `
  --auth pat `
  --token $(AgentPATToken) `
  --pool $(AgentPool) `
  --agent $(MachineName)$(AgentUserName) `
  --runAsAutoLogon `
  --windowsLogonAccount $(AgentUserName) `
  --windowsLogonPassword $(AgentPassword) `
  --overwriteautologon
#