fn main() {
    let asset_fields = [
        "asset_id",
        "asset_class",
        "asset_name",
        "location",
        "owner",
        "install_year",
        "design_life_years",
        "replacement_cost",
        "service_role",
        "operational_status",
    ];

    let work_order_fields = [
        "work_order_id",
        "asset_id",
        "created_date",
        "maintenance_strategy",
        "priority",
        "status",
        "estimated_cost",
    ];

    println!("Asset register validator scaffold");
    println!("Required asset-register fields:");
    for field in asset_fields {
        println!("- {}", field);
    }

    println!("Required work-order fields:");
    for field in work_order_fields {
        println!("- {}", field);
    }
}
