using H3_AppProgrammering___Scrum_Board.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace H3_AppProgrammering___Scrum_Board.Controllers
{
    [Route("api/[controller]")]
    public class AuthenticationController : Controller
    {

        [HttpPost("login")]
        public IActionResult Login([FromBody] Login user)
        {
            if (user is null)
            {
                return BadRequest("Invalid user request!!!");
            }
            if (user.Username == "FlutterTester" && user.Password == "FlutterTest")
            {
                var secretKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("SuperSecretJwtKeyWithSoManyCharactersThatYouWouldNotBelieveItButAlasHereItIsTheSuperLongKey"));
                var signinCredentials = new SigningCredentials(secretKey, SecurityAlgorithms.HmacSha256);
                var tokenOptions = new JwtSecurityToken(
                    issuer: "http://localhost:5002",
                    audience: "http://localhost:5002",
                    claims: new List<Claim>(),
                    expires: DateTime.Now.AddMinutes(1),
                    signingCredentials: signinCredentials
                );
                var tokenString = new JwtSecurityTokenHandler().WriteToken(tokenOptions);
                return Ok(new JwtAccessToken { Token = tokenString });
            }
            return Unauthorized();
        }
    }
}
