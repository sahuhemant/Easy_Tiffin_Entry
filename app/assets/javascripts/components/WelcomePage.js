import React from 'react';

const WelcomePage = () => {
  return (
    <div>
      <h1>Welcome!</h1>
      <p>Please choose an option:</p>
      <div>
        <a href="/login" className="btn btn-primary">Login</a>
        <a href="/register" className="btn btn-secondary">Register</a>
      </div>
    </div>
  );
};

export default WelcomePage;
