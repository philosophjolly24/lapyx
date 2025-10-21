import { useState, type Dispatch, type SetStateAction } from "react";

export default function AgentSidebar() {
  const [sidebarMode, setSidebarMode] = useState<"agents" | "sequence">(
    "agents"
  );
  const [agentSort, setAgentSort] = useState<"all" | "on map" | "role">("all");
  return (
    <div className="bg-secondary h-auto mb-4 rounded-md flex flex-col gap-3 items-center just">
      {/* agent sequence header */}
      <div className="flex items-center justify-center gap-3 w-[90%]">
        <div className=" grow flex items-center justify-center w-10 mt-3 ">
          <img src="/caret.svg" width={32} height={32} className="" />
        </div>
        <div className=" flex items-center justify-between grow bg-[#2e2e2e]/25 mt-3 mr-3 rounded-md h-10 w-[90%]">
          <button
            className={` w-full h-full font-bold text-2xl tracking-wide transition-all ease-in-out duration-150 ${
              sidebarMode === "agents" ? "bg-main  rounded " : null
            }`}
            onClick={() => {
              setSidebarMode("agents");
            }}
          >
            Agents
          </button>
          <button
            className={` w-full h-full  font-bold text-2xl tracking-wide   ${
              sidebarMode === "sequence"
                ? "animate-slide bg-main h-full rounded "
                : null
            }`}
            onClick={() => {
              setSidebarMode("sequence");
            }}
          >
            Sequences
          </button>
        </div>
      </div>

      {sidebarMode === "agents" ? (
        <AgentCard agentSort={agentSort} setAgentSort={setAgentSort} />
      ) : (
        <Sequences />
      )}
    </div>
  );
}

interface AgentCardProps {
  agentSort?: "all" | "on map" | "role";
  setAgentSort: Dispatch<SetStateAction<"all" | "on map" | "role">>;
}

function AgentCard({ agentSort, setAgentSort }: AgentCardProps) {
  return (
    <div className="flex flex-col w-full h-full gap-3 items-center justify-center mb-3">
      <div className="bg-[#2e2e2e]/25  w-[90%]  rounded-md grow"></div>

      <div className="bg-[#2e2e2e]/25 w-[90%] rounded-md grow-[3] flex flex-col items-center">
        <div className="flex items-center justify-center gap-3 w-[90%]">
          <div className=" flex items-center justify-between grow bg-[#2e2e2e]/25 mt-3 mr-3 rounded-md h-10 w-[90%]">
            <button
              className={` w-full h-full font-bold text-lg tracking-wide rounded ${
                agentSort === "all" ? "bg-main  rounded " : null
              } `}
              onClick={() => setAgentSort("all")}
            >
              All
            </button>
            <button
              className={` w-full h-full  font-bold text-lg tracking-wide rounded ${
                agentSort === "on map" ? "bg-main  rounded " : null
              }  `}
              onClick={() => setAgentSort("on map")}
            >
              On Map
            </button>
            <button
              className={` w-full h-full  font-bold text-lg tracking-wide rounded ${
                agentSort === "role" ? "bg-main  rounded " : null
              } `}
              onClick={() => setAgentSort("role")}
            >
              Role
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
function Sequences() {
  return <></>;
}
