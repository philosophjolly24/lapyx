import Dexie, { type EntityTable } from "dexie";

interface Folder {
  id: string;
}
interface Strategy {
  id: string;
}

const db = new Dexie("LaphyxDB") as Dexie & {
  Folders: EntityTable<
    Folder,
    "id" // primary key "id"
  >;
  Strategies: EntityTable<
    Strategy,
    "id" // primary key "id"
  >;
};

// Schema declaration:
db.version(1).stores({
  //   lists: "id, name,created_at,updated_at",
  //   items: "id,list_id,name,notes,checked,price,quantity,unit",
  folders: "",
  strategies: "",
});

export type {};
export { db };
