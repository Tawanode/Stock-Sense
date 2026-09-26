import * as productRepository from "./product.repository.js";

function serializeProduct(product: any) {
    return {
        ...product,
        id: product.id.toString(),
        categoryId: product.categoryId.toString(),
        unitId: product.unitId.toString(),

        category: product.category
            ? {
                ...product.category,
                id: product.category.id.toString(),
            }
            : null,

        unit: product.unit
            ? {
                ...product.unit,
                id: product.unit.id.toString(),
            }
            : null,

        stocks:
            product.stocks?.map((stock: any) => ({
                ...stock,
                id: stock.id.toString(),
                productId: stock.productId.toString(),
                locationId: stock.locationId.toString(),
                quantity: stock.quantity.toString(),
                reservedQuantity: stock.reservedQuantity.toString(),

                location: stock.location
                    ? {
                        ...stock.location,
                        id: stock.location.id.toString(),
                        warehouseId: stock.location.warehouseId.toString(),

                        warehouse: stock.location.warehouse
                            ? {
                                ...stock.location.warehouse,
                                id: stock.location.warehouse.id.toString(),
                            }
                            : null,
                    }
                    : null,
            })) ?? [],

        reorderRules:
            product.reorderRules?.map((rule: any) => ({
                ...rule,
                id: rule.id.toString(),
                productId: rule.productId.toString(),
                locationId: rule.locationId.toString(),
                minimumQuantity: rule.minimumQuantity.toString(),
                maximumQuantity: rule.maximumQuantity?.toString() ?? null,
                reorderQuantity: rule.reorderQuantity.toString(),
            })) ?? [],
    };
}

export async function getProducts(params: {
    search?: string;
    categoryId?: bigint;
    isActive?: boolean;
}) {
    const products = await productRepository.findProducts(params);

    return products.map(serializeProduct);
}

export async function getProduct(id: bigint) {
    const product = await productRepository.findProductById(id);

    if (!product) {
        throw new Error("Product not found");
    }

    return serializeProduct(product);
}

export async function createProduct(data: {
    name: string;
    sku: string;
    categoryId: bigint;
    unitId: bigint;
}) {
    const existingProduct = await productRepository.findProductBySku(data.sku);

    if (existingProduct) {
        throw new Error("A product with this SKU already exists");
    }

    const product = await productRepository.createProduct(data);

    return serializeProduct(product);
}

export async function updateProduct(
    id: bigint,
    data: {
        name?: string;
        sku?: string;
        categoryId?: bigint;
        unitId?: bigint;
        isActive?: boolean;
    },
) {
    const existingProduct = await productRepository.findProductById(id);

    if (!existingProduct) {
        throw new Error("Product not found");
    }

    if (data.sku && data.sku !== existingProduct.sku) {
        const skuExists = await productRepository.findProductBySku(data.sku);

        if (skuExists) {
            throw new Error("A product with this SKU already exists");
        }
    }

    const product = await productRepository.updateProduct(id, data);

    return serializeProduct(product);
}