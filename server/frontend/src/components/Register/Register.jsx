import React, { useState } from "react";
import "./Register.css";
import Header from "../Header/Header";

const Register = () => {
  const [userName, setUserName] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const register = async (e) => {
    e.preventDefault();

    try {
      const response = await fetch(window.location.origin + "/djangoapp/register", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          userName,
          firstName,
          lastName,
          email,
          password
        })
      });

      const result = await response.json();
      if (response.ok) {
        alert(result.message || "Registration successful. You can now sign in.");
      } else {
        alert(result.message || "Registration failed. Please check your details.");
      }
    } catch (error) {
      alert("Unable to register right now. Please try again.");
    }
  };

  return (
    <div>
      <Header />
      <main className="register_container">
        <h1 className="header">Sign-up</h1>
        <form className="inputs" onSubmit={register}>
          <label className="input">
            <span>Username</span>
            <input
              className="input_field"
              type="text"
              name="username"
              placeholder="Username"
              value={userName}
              onChange={(e) => setUserName(e.target.value)}
              required
            />
          </label>

          <label className="input">
            <span>First Name</span>
            <input
              className="input_field"
              type="text"
              name="firstName"
              placeholder="First Name"
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
              required
            />
          </label>

          <label className="input">
            <span>Last Name</span>
            <input
              className="input_field"
              type="text"
              name="lastName"
              placeholder="Last Name"
              value={lastName}
              onChange={(e) => setLastName(e.target.value)}
              required
            />
          </label>

          <label className="input">
            <span>Email</span>
            <input
              className="input_field"
              type="email"
              name="email"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </label>

          <label className="input">
            <span>Password</span>
            <input
              className="input_field"
              type="password"
              name="password"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </label>

          <div className="submit_panel">
            <button className="submit" type="submit">Register</button>
          </div>
        </form>
      </main>
    </div>
  );
};

export default Register;
