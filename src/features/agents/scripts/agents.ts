const agents: agent[] = [
  { name: "Astra", role: "controller" },
  { name: "Breach", role: "initiator" },
  { name: "Brimstone", role: "controller" },
  { name: "Chamber", role: "sentinel" },
  { name: "Clove", role: "controller" },
  { name: "Cypher", role: "sentinel" },
  { name: "Deadlock", role: "sentinel" },
  { name: "Fade", role: "initiator" },
  { name: "Gekko", role: "initiator" },
  { name: "Harbor", role: "controller" },
  { name: "Iso", role: "duelist" },
  { name: "Jett", role: "duelist" },
  { name: "Kayo", role: "initiator" },
  { name: "Killjoy", role: "sentinel" },
  { name: "Neon", role: "duelist" },
  { name: "Omen", role: "controller" },
  { name: "Phoenix", role: "duelist" },
  { name: "Raze", role: "duelist" },
  { name: "Reyna", role: "duelist" },
  { name: "Sage", role: "sentinel" },
  { name: "Skye", role: "initiator" },
  { name: "Sova", role: "initiator" },
  { name: "Tejo", role: "initiator" },
  { name: "Veto", role: "sentinel" },
  { name: "Viper", role: "controller" },
  { name: "Vyse", role: "sentinel" },
  { name: "Waylay", role: "duelist" },
  { name: "Yoru", role: "duelist" },
];

interface agent {
  name: string;
  role: string;
}

export { agents, type agent };
