import "temporal-polyfill/full/global";
import { db } from "../../prisma/db";

export const prisma = db;