import React, { useState, type Dispatch, type SetStateAction } from "react";

import { agents, type agent } from "../scripts/agents";
import AgentIcon from "./AgentIcon";

interface AgentCardProps {
  agentSort?: "all" | "on map" | "role";
  setAgentSort: Dispatch<SetStateAction<"all" | "on map" | "role">>;
  currentAgent: agent;
  setCurrentAgent: React.Dispatch<React.SetStateAction<agent>>;
}

interface CurrentAgentCardProps {
  currentAgent: agent;
  setCurrentAgent: React.Dispatch<React.SetStateAction<agent>>;
}

function AgentSelect({
  agentSort,
  setAgentSort,
  setCurrentAgent,
  currentAgent,
}: AgentCardProps) {
  return (
    <div className=" h-full w-full flex flex-col items-center gap-3">
      {/* current agent */}
      <div className=" bg-main/25 w-[95%] rounded-md  min-h-[200px] ">
        <CurrentAgentCard
          currentAgent={currentAgent}
          setCurrentAgent={setCurrentAgent}
        ></CurrentAgentCard>
      </div>
      {/* all agents */}
      <div className=" w-[95%] flex flex-col items-center grow ">
        {/* agents sort button bar */}
        <div className=" flex items-center justify-between bg-unactive rounded-md min-h-10 w-full my-3 ">
          <button
            className={` w-full h-full font-bold text-lg tracking-wide rounded ${
              agentSort === "all" ? "bg-active  rounded " : null
            } `}
            onClick={() => setAgentSort("all")}
          >
            All
          </button>

          <button
            className={` w-full h-full  font-bold text-lg tracking-wide rounded ${
              agentSort === "on map" ? "bg-active  rounded " : null
            }  `}
            onClick={() => setAgentSort("on map")}
          >
            On Map
          </button>

          <button
            className={` w-full h-full  font-bold text-lg tracking-wide rounded ${
              agentSort === "role" ? "bg-active  rounded " : null
            } `}
            onClick={() => setAgentSort("role")}
          >
            Role
          </button>
        </div>
        {/* agent selector */}
        <div className="overflow-y-auto scrollbar-hide grow w-full px-3 pb-8 h-0">
          <ul className="grid grid-cols-4 w-full gap-4 rounded-md">
            {agents.map((agent) => {
              return (
                <li
                  key={agent.name}
                  onClick={() => {
                    setCurrentAgent(agent);
                  }}
                  className="aspect-square"
                >
                  <div className=" flex items-center justify-center bg-main/25 rounded-md">
                    <img
                      src={`/agents/${agent.name}/icon.webp`}
                      alt={`${agent.name}`}
                      width={32}
                      height={32}
                      className="w-fit h-fit rounded-md"
                    />
                  </div>
                </li>
              );
            })}
          </ul>
        </div>
      </div>
    </div>
    // agent card
  );
}

function CurrentAgentCard({ currentAgent }: CurrentAgentCardProps) {
  const [isAlly, setIsAlly] = useState(true);

  return (
    <div>
      <div className="flex justify-around items-center content-center gap-3  w-full ">
        <AgentIcon agent={currentAgent} />

        <div className=" flex flex-col grow my-3">
          <div className="flex flex-col items-center justify-center">
            <p className="font-bold text-3xl pb-3">{`${currentAgent.name}`}</p>

            <div className=" flex items-center justify-center bg-main/25 rounded-md w-12 h-12">
              <img
                src={`/agents/${currentAgent.role}.webp`}
                alt={`${currentAgent.name}`}
                width={32}
                height={32}
              />
            </div>
          </div>

          <button
            className={`grow h-10 rounded-md text-lg font-bold my-4 mx-5 ${
              isAlly ? `bg-green-700` : `bg-red-500`
            }`}
            onClick={() => setIsAlly(!isAlly)}
          >
            {isAlly ? "Ally" : "Enemy"}
          </button>
        </div>
      </div>

      <ul className="flex items-center justify-around my-3">
        <li className=" flex items-center justify-center  bg-main/25 rounded-md h-12 w-12 ">
          <img
            src={`/agents/${currentAgent.name}/1.webp`}
            alt={`${currentAgent.name}`}
            width={36}
            height={36}
          />
        </li>

        <li className=" flex items-center justify-center  bg-main/25 rounded-md h-12 w-12 ">
          <img
            src={`/agents/${currentAgent.name}/3.webp`}
            alt={`${currentAgent.name}`}
            width={36}
            height={36}
          />
        </li>

        <li className=" flex items-center justify-center  bg-main/25 rounded-md h-12 w-12">
          <img
            src={`/agents/${currentAgent.name}/2.webp`}
            alt={`${currentAgent.name}`}
            width={36}
            height={36}
          />
        </li>

        <li className=" flex items-center justify-center  bg-main/25 rounded-md h-12 w-12">
          <img
            src={`/agents/${currentAgent.name}/4.webp`}
            alt={`${currentAgent.name}`}
            width={36}
            height={36}
          />
        </li>
      </ul>
    </div>
  );
}

export default React.memo(AgentSelect);

// TODO: hide or fix the agent list styling
