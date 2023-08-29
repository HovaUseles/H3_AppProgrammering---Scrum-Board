using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace H3_AppProgrammering___Scrum_Board.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    public class HomeController : Controller
    {
        [HttpGet]
        public IActionResult Index()
        {
            return Ok("Hello world!");
        }
    }
}
