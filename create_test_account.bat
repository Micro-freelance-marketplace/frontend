@echo off
echo Creating test account for Campus Freelance Marketplace...
echo.

echo Creating account: test@university.edu
curl -X POST http://localhost:5000/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"Test User\",\"email\":\"test@university.edu\",\"password\":\"test123456\",\"role\":\"freelancer\",\"campus\":\"Test Campus\"}"

echo.
echo Account created successfully!
echo Email: test@university.edu
echo Password: test123456
echo.
pause
