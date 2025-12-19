// client/src/components/ThemeToggle.jsx
import React from "react";
import { Button } from "react-bootstrap";
import { MoonStarsFill, SunFill } from "react-bootstrap-icons";
import { useTheme } from "../context/ThemeContext";

const ThemeToggle = ({ className }) => {
  const { theme, toggleTheme } = useTheme();

  return (
    <Button
      variant={theme === "light" ? "outline-dark" : "outline-light"}
      onClick={toggleTheme}
      className={`rounded-circle p-2 d-flex align-items-center justify-content-center ${className}`}
      title={
        theme === "light" ? "Chuyển sang chế độ tối" : "Chuyển sang chế độ sáng"
      }
      style={{ width: "40px", height: "40px" }}
    >
      {theme === "light" ? (
        <MoonStarsFill size={20} />
      ) : (
        <SunFill size={20} color="gold" />
      )}
    </Button>
  );
};

export default ThemeToggle;
