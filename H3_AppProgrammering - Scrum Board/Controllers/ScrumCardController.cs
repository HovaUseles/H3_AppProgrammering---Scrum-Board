using H3_AppProgrammering___Scrum_Board.DataHandlers;
using H3_AppProgrammering___Scrum_Board.DTO;
using H3_AppProgrammering___Scrum_Board.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Entities;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace H3_AppProgrammering___Scrum_Board.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ScrumCardController : ControllerBase
    {
        private readonly ScrumCardDataHandler _dataHandler;

        public ScrumCardController(ScrumCardDataHandler dataHandler)
        {
            _dataHandler = dataHandler;
        }

        // GET: api/<ScrumCardController>
        [HttpGet]
        public async Task<IActionResult> Get()
        {
            return Ok(await _dataHandler.GetAll());
        }

        // GET api/<ScrumCardController>/5
        [HttpGet("{id}")]
        public async Task<IActionResult> Get(string id)
        {
            return Ok(await _dataHandler.GetById(id));
        }

        // POST api/<ScrumCardController>
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] ScrumCardDTO dto)
        {
            if (ModelState.IsValid) 
            {
                ScrumCard scrumCard = new ScrumCard(dto);

                // Save entity
                scrumCard = await _dataHandler.Create(scrumCard);

                return Created($"api/[controller]/{scrumCard.ID}", scrumCard);
            }
            return BadRequest();
        }

        // PUT api/<ScrumCardController>/5
        [HttpPut("{id}")]
        public async Task<IActionResult> Put([FromBody] ScrumCard scrumCardChanges)
        {
            await _dataHandler.Update(scrumCardChanges);
            return NoContent();
        }

        // DELETE api/<ScrumCardController>/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            await _dataHandler.Delete(id);
            return NoContent();
        }
    }
}
