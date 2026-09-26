import { db } from './prisma/db'; const q = db.orm.public.Products.where({}); type T = keyof typeof q; const k: T = 'toArray';
