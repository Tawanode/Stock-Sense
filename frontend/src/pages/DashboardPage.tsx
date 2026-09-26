import { useAuth } from "../features/auth/AuthContext";

export default function DashboardPage() {
  const { user } = useAuth();

  return (
    <div>
      <h1>Inventory Dashboard</h1>

      <p>
        Welcome, {user?.name}
      </p>

      <p>
        Role: {user?.role}
      </p>
    </div>
  );
}
