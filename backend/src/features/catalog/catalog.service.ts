import * as repository from "./catalog.repository.js";

// --------------------
// Categories
// --------------------

export async function getCategories() {
    const categories = await repository.findCategories();

    return categories.map((category) => ({
        ...category,
        id: category.id.toString(),
    }));
}

export async function createCategory(data: {
    name: string;
    description?: string;
}) {
    const existing = await repository.findCategoryByName(data.name);

    if (existing) {
        throw new Error("A category with this name already exists");
    }

    const category = await repository.createCategory(data);

    return {
        ...category,
        id: category.id.toString(),
    };
}

export async function updateCategory(
    id: bigint,
    data: {
        name?: string;
        description?: string;
    },
) {
    const existing = await repository.findCategoryById(id);

    if (!existing) {
        throw new Error("Category not found");
    }

    if (data.name && data.name !== existing.name) {
        const duplicate = await repository.findCategoryByName(data.name);

        if (duplicate) {
            throw new Error("A category with this name already exists");
        }
    }

    const category = await repository.updateCategory(id, data);

    if (!category) {
        throw new Error("Failed to update category");
    }

    return {
        ...category,
        id: category.id.toString(),
    };
}

// --------------------
// Units
// --------------------

export async function getUnits() {
    const units = await repository.findUnits();

    return units.map((unit) => ({
        ...unit,
        id: unit.id.toString(),
    }));
}

export async function createUnit(data: {
    name: string;
    symbol: string;
}) {
    const existingName = await repository.findUnitByName(data.name);

    if (existingName) {
        throw new Error("A unit with this name already exists");
    }

    const existingSymbol = await repository.findUnitBySymbol(data.symbol);

    if (existingSymbol) {
        throw new Error("A unit with this symbol already exists");
    }

    const unit = await repository.createUnit(data);

    return {
        ...unit,
        id: unit.id.toString(),
    };
}

export async function updateUnit(
    id: bigint,
    data: {
        name?: string;
        symbol?: string;
    },
) {
    const existing = await repository.findUnitById(id);

    if (!existing) {
        throw new Error("Unit not found");
    }

    if (data.name && data.name !== existing.name) {
        const duplicateName = await repository.findUnitByName(data.name);

        if (duplicateName) {
            throw new Error("A unit with this name already exists");
        }
    }

    if (data.symbol && data.symbol !== existing.symbol) {
        const duplicateSymbol = await repository.findUnitBySymbol(data.symbol);

        if (duplicateSymbol) {
            throw new Error("A unit with this symbol already exists");
        }
    }

    const unit = await repository.updateUnit(id, data);

    if (!unit) {
        throw new Error("Failed to update unit");
    }

    return {
        ...unit,
        id: unit.id.toString(),
    };
}