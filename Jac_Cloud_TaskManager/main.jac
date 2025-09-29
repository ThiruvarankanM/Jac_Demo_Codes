# main.jac - Simple Task Manager
import from datetime { datetime }

node TaskManager {
    has created_at: str;

    def create_task(title: str) -> dict {
        new_task = Task(title=title, status="pending");
        self ++> new_task;
        return {"status": "created", "task": title};
    }

    def list_tasks() -> list[dict] {
        tasks = [self --> Task];
        return [
            {"title": t.title, "status": t.status}
            for t in tasks
        ];
    }
}

node Task {
    has title: str;
    has status: str = "pending";

    def complete() -> str {
        self.status = "completed";
        return self.status;
    }
}

walker create_task {
    has title: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can create_task_endpoint with `root entry {
        manager_nodes = [root --> TaskManager];
        if not manager_nodes {
            manager = TaskManager(created_at=str(datetime.now()));
            root ++> manager;
        } else {
            manager = manager_nodes[0];
        }

        result = manager.create_task(self.title);
        report result;
    }
}

walker list_tasks {
    obj __specs__ {
        static has auth: bool = False;
    }

    can list_tasks_endpoint with `root entry {
        manager_nodes = [root --> TaskManager];
        if not manager_nodes {
            report {"tasks": []};
            return;
        }

        manager = manager_nodes[0];
        tasks = manager.list_tasks();
        report {"tasks": tasks};
    }
}

walker complete_task {
    has title: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can complete_task_endpoint with `root entry {
        manager_nodes = [root --> TaskManager];
        if not manager_nodes {
            report {"error": "No manager found"};
            return;
        }

        manager = manager_nodes[0];
        tasks = [manager --> Task](?title == self.title);

        if not tasks {
            report {"error": "Task not found"};
            return;
        }

        task = tasks[0];
        new_status = task.complete();
        report {"task": self.title, "status": new_status};
    }
}