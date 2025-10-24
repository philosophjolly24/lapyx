import MapPicker from "@/features/maps/components/MapPicker";
import "@/styles/background/bg.css";
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { currentMapPool } from "@/features/maps/scripts/maps";
import AgentSidebar from "@/features/agents/components/AgentSidebar";

export default function Strategy() {
  const [currentMap, setCurrentMap] = useState(currentMapPool[1]);
  const [isAttack, setIsAttack] = useState(true);
  const [mapSide, setMapSide] = useState<string | null>("atk");
  const navigate = useNavigate();

  useEffect(() => {
    const timer = setTimeout(() => {
      setMapSide(isAttack ? "atk" : "def");
    }, 250);

    return () => clearTimeout(timer);
  }, [isAttack]);

  return (
    <div className="grid grid-cols-4 gap-4 h-screen w-full overflow-hidden my-2">
      <div className="col-span-3 max-h-screen">
        {/* top toolbar */}
        <div className="flex items-center justify-between mb-2">
          <div className="flex flex-row gap-4">
            {/* home icon */}
            <div
              className=" w-16 h-16 flex items-center justify-center bg-main/20  hover:bg-main/50 transition-colors duration-150 rounded-md"
              onClick={() => {
                navigate("/");
              }}
            >
              <img src="/home.svg" width={40} height={40} alt="home" />
            </div>

            {/* map selector */}
            <MapPicker
              setCurrentMap={setCurrentMap}
              currentMap={currentMap}
            ></MapPicker>

            {/* starting side */}
            <div
              className="bg-main rounded-md h-16 w-16 flex  flex-col items-center justify-center"
              onClick={() => {
                setIsAttack(!isAttack);
              }}
            >
              <img
                src={`${isAttack ? "/attack.svg" : "/defense.svg"}`}
                alt={`${isAttack ? "attack" : "defense"}`}
                width={32}
                height={32}
              />
              <p className=" text-off-white font-semibold text-lg tracking-wider">
                {`${isAttack ? "ATK" : "DEF"}`}
              </p>
            </div>
          </div>
          {/* Top menu bar */}
          <div className="grow px-[5%]">
            <div className=" flex items-center justify-around gap-4 min-w-[212px] w-full h-16 rounded-md bg-main/20 mx-auto aspect-auto">
              {/* settings icon */}
              <div className=" flex items-center justify-center w-13 h-13 hover:bg-main/50  transition-colors duration-150 rounded-md ">
                <img
                  src="/settings.svg"
                  width={44}
                  height={44}
                  alt=" settings"
                  loading="lazy"
                />
              </div>
              {/* save icon */}
              <div className=" flex items-center justify-center w-13 h-13 hover:bg-main/50  transition-colors duration-150 rounded-md ">
                <img
                  src="/save.svg"
                  width={44}
                  height={44}
                  alt=" save"
                  loading="lazy"
                />
              </div>
              {/* screenshot icon */}
              <div className=" flex items-center justify-center w-13 h-13 hover:bg-main/50  transition-colors duration-150 rounded-md ">
                <img
                  src="/screenshot.svg"
                  width={44}
                  height={44}
                  alt=" screenshot"
                  loading="lazy"
                />
              </div>
              {/* download icon */}
              <div className=" flex items-center justify-center w-13 h-13 hover:bg-main/50  transition-colors duration-150 rounded-md ">
                <img
                  src="/download.svg"
                  width={44}
                  height={44}
                  alt=" download"
                  loading="lazy"
                />
              </div>
            </div>

            {/* delete */}
          </div>
          <div className=" w-16 h-16 rounded-md flex items-center justify-center bg-main/20 hover:bg-main/50 aspect-square">
            <img
              width={36}
              height={36}
              src="/delete.svg"
              alt=""
              loading="lazy"
            />
          </div>
        </div>
        {/* map */}
        <div className="flex items-center justify-center overflow-hidden h-[90%] w-full">
          <img
            src={`/maps/${currentMap}_${mapSide}.svg`}
            alt=""
            loading="lazy"
            className={`transition-transform duration-300 ease-in-out
                object-contain max-h-full w-full ${
                  isAttack ? "rotate-0" : "rotate-360"
                } }`}
          />
        </div>

        {/* bottom toolbar */}

        {/* <div className="flex items-center justify-center bg-red-400 h-7"></div> */}
      </div>
      {/* sidebar */}
      <div className="h-screen overflow-y-hidden scrollbar-hidden rounded-md">
        <AgentSidebar />
      </div>
    </div>
  );
}
// // TODO: re-colour the sites on both atk and def sides
// TODO: apply the rotation and side switching logic
// TODO: complete the agent sidebar
// TODO:  prevent page zoom ???
