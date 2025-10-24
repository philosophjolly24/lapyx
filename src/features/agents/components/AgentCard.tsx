import React, { useState, type Dispatch, type SetStateAction } from "react";

import { agents, type agent } from "../scripts/agents";

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

function AgentCard({
  agentSort,

  setAgentSort,

  setCurrentAgent,

  currentAgent,
}: AgentCardProps) {
  return (
    <div className="flex flex-col w-full h-full gap-3 items-center justify-center mb-3">
      <div className="bg-[#2e2e2e]/25 w-[90%] rounded-md grow mt-3">
        <CurrentAgentCard
          currentAgent={currentAgent}
          setCurrentAgent={setCurrentAgent}
        />
      </div>

      <div className="bg-[#2e2e2e]/25 w-[90%] rounded-md flex flex-col items-center justify-between  h-full">
        <div className="flex flex-col items-center justify-center gap-3 w-[90%] h-[95%]">
          <div className=" flex items-center justify-between bg-[#2e2e2e]/25 mt-3  rounded-md h-14 w-full my-3 ">
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

          <div className="overflow-y-auto scrollbar-hide h-[90%] pb-3">
            <ul className="grid grid-cols-4 w-full gap-4">
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
                        className="w-fit h-fit"
                      />
                    </div>
                  </li>
                );
              })}
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}

function CurrentAgentCard({ currentAgent }: CurrentAgentCardProps) {
  const [isAlly, setIsAlly] = useState(true);

  return (
    <div>
      <div className="flex justify-around content-center gap-3  w-full ">
        <div className=" flex items-center justify-center  bg-main/25 rounded-md  my-4 ml-3">
          <img
            src={`/agents/${currentAgent.name}/icon.webp`}
            alt={`${currentAgent.name}`}
            width={120}
            height={120}
            className="object-cover w-full h-full"
          />
        </div>

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

export default React.memo(AgentCard);
