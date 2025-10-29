import { useState } from "react";
import AgentCard from "./AgentSelect";
import { type agent, agents } from "../scripts/agents";

export default function AgentSidebar() {
  const [sidebarMode, setSidebarMode] = useState<"agents" | "sequence">(
    "agents"
  );
  const [agentSort, setAgentSort] = useState<"all" | "on map" | "role">("all");
  const [currentAgent, setCurrentAgent] = useState<agent>(agents[0]);

  console.log(currentAgent);
  return (
    <div className="relative bg-secondary h-full rounded-md flex flex-col  items-center">
      {/* agent sequence header */}
      <div className=" absolute top-0 left-0  w-10  ">
        <img src="/caret.svg" width={32} height={32} className="" />
      </div>
      <div className="flex items-center justify-center gap-3 w-full mx-2">
        <div className=" flex items-center justify-between  bg-[#2e2e2e]/25 my-3 mr-3 rounded-md h-10 w-[90%]">
          <button
            className={` w-full h-full font-bold text-2xl tracking-wide transition-all ease-in-out md:text-lg duration-150 ${
              sidebarMode === "agents" ? "bg-active  rounded " : null
            }`}
            onClick={() => {
              setSidebarMode("agents");
            }}
          >
            Agents
          </button>
          <button
            className={` w-full h-full  font-bold text-2xl tracking-wide md:text-lg  ${
              sidebarMode === "sequence"
                ? "animate-slide bg-active h-full rounded "
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
        <div className="grow w-full">
          <AgentCard
            agentSort={agentSort}
            setAgentSort={setAgentSort}
            currentAgent={currentAgent}
            setCurrentAgent={setCurrentAgent}
          />
        </div>
      ) : (
        <Sequences />
      )}
    </div>
  );
}

function Sequences() {
  return <></>;
}
