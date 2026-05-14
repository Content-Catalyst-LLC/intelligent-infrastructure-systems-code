#include <iostream>
#include <queue>
#include <string>
#include <vector>

struct MaintenanceEvent {
    std::string asset_id;
    std::string asset_class;
    double priority_score;
    std::string strategy;
};

struct ComparePriority {
    bool operator()(const MaintenanceEvent& a, const MaintenanceEvent& b) {
        return a.priority_score < b.priority_score;
    }
};

int main() {
    std::priority_queue<MaintenanceEvent, std::vector<MaintenanceEvent>, ComparePriority> queue;

    queue.push({"A-0004", "bridge_component", 0.75, "urgent_review"});
    queue.push({"A-0007", "pipe_segment", 0.80, "urgent_review"});
    queue.push({"A-0001", "pump", 0.53, "condition_based_maintenance"});

    while (!queue.empty()) {
        MaintenanceEvent event = queue.top();
        queue.pop();

        std::cout << "asset=" << event.asset_id
                  << " class=" << event.asset_class
                  << " priority=" << event.priority_score
                  << " strategy=" << event.strategy
                  << std::endl;
    }

    return 0;
}
