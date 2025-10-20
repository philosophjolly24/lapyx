import MapPicker from "@/features/maps/components/MapPicker";
import "@/styles/background/bg.css";
import { useState } from "react";
import { useNavigate } from "react-router-dom";

export default function Strategy() {
  const [currentMap, setCurrentMap] = useState("ascent");
  const navigate = useNavigate();
  return (
    <div className="grid grid-cols-4 gap-4 pt-4">
      <div className="col-span-3 ">
        {/* top toolbar */}
        <div className="flex items-center justify-between mb-4">
          <div className="flex flex-row gap-4">
            {/* home icon */}
            <div
              className=" w-16 h-16 flex items-center justify-center bg-main-button/20  hover:bg-main-button/50 transition-colors duration-150 rounded-md"
              onClick={() => {
                navigate("/");
              }}
            >
              <img src="/home.svg" width={40} height={40} alt="home" />
            </div>

            {/* map selector (aria dropbox)*/}
            <MapPicker
              setCurrentMap={setCurrentMap}
              currentMap={currentMap}
            ></MapPicker>

            {/* starting side */}
            <div className="bg-main-button rounded-md h-16 w-16 flex  flex-col items-center justify-center">
              <img src="/attack.svg" alt="attack" width={32} height={32} />
              <p className=" text-off-white font-semibold text-lg">ATK</p>
            </div>
          </div>
          {/*  menu */}
          <div className="grow">
            <div className=" flex items-center justify-around gap-4 min-w-[212px] w-[48%] h-16 rounded-md bg-main-button/20 mx-auto">
              {/* settings icon */}
              <div className=" flex items-center justify-center w-13 h-13 hover:bg-main-button/50  transition-colors duration-150 rounded-md ">
                <img
                  src="/settings.svg"
                  width={44}
                  height={44}
                  alt=" settings"
                />
              </div>
              {/* save icon */}
              <div className=" flex items-center justify-center w-13 h-13 hover:bg-main-button/50  transition-colors duration-150 rounded-md ">
                <img src="/save.svg" width={44} height={44} alt=" save" />
              </div>
              {/* screenshot icon */}
              <div className=" flex items-center justify-center w-13 h-13 hover:bg-main-button/50  transition-colors duration-150 rounded-md ">
                <img
                  src="/screenshot.svg"
                  width={44}
                  height={44}
                  alt=" screenshot"
                />
              </div>
              {/* download icon */}
              <div className=" flex items-center justify-center w-13 h-13 hover:bg-main-button/50  transition-colors duration-150 rounded-md ">
                <img
                  src="/download.svg"
                  width={44}
                  height={44}
                  alt=" download"
                />
              </div>
            </div>

            {/* delete */}
          </div>
          <div className=" w-16 h-16 rounded-md flex items-center justify-center bg-main-button/20 hover:bg-main-button/50">
            <img width={36} height={36} src="/delete.svg" alt="" />
          </div>
        </div>
        {/* map */}
        <div className="flex items-center justify-center bg-red-200 h-7"></div>
        {/* bottom toolbar */}
        <div className="flex items-center justify-center bg-red-400 h-7"></div>
      </div>
      <div className="bg-[#622b5b] h-5  "></div>
    </div>
  );
}
