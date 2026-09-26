import {
  BrowserRouter,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";

import { AuthProvider } from "./features/auth/AuthContext";

import LoginPage from "./features/auth/LoginPage";
import SignupPage from "./features/auth/SignupPage";

import DashboardPage from "./pages/DashboardPage";

import ProtectedRoute from "./routes/ProtectedRoute";

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route
            path="/login"
            element={<LoginPage />}
          />

          <Route
            path="/signup"
            element={<SignupPage />}
          />

          <Route element={<ProtectedRoute />}>
            <Route
              path="/dashboard"
              element={<DashboardPage />}
            />
          </Route>

          <Route
            path="*"
            element={
              <Navigate
                to="/dashboard"
                replace
              />
            }
          />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;