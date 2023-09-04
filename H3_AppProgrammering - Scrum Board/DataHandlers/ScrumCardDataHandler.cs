using H3_AppProgrammering___Scrum_Board.Models;
using MongoDB.Entities;

namespace H3_AppProgrammering___Scrum_Board.DataHandlers
{
    public class ScrumCardDataHandler
    {
        public ScrumCardDataHandler()
        {
            DB.InitAsync("ScrumBoard", "localhost", 27017);
        }
        public async Task<ScrumCard> GetById(string id)
        {
            return await DB.Find<ScrumCard>().OneAsync(id);
        }

        public async Task<IEnumerable<ScrumCard>> GetAll()
        {
            return await DB.Find<ScrumCard>().ManyAsync(_ => true);
        }

        public async Task<ScrumCard> Create(string index, string title, string content, string scrumColumn)
        {
            ScrumCard galleryEntry = new ScrumCard(
                index,
                title,
                content,
                scrumColumn);

            await galleryEntry.SaveAsync();
            return galleryEntry;
        }

        public async Task<ScrumCard> Create(ScrumCard scrumCard)
        {
            await scrumCard.SaveAsync();
            return scrumCard;
        }


        public async Task<ScrumCard> Update(ScrumCard scrumCardChanges)
        {
            return await DB.UpdateAndGet<ScrumCard>()
                    .MatchID(scrumCardChanges.ID)
                    .ModifyWith(scrumCardChanges)
                    .ExecuteAsync();
        }

        public async Task Delete(string id)
        {
            await DB.DeleteAsync<ScrumCard>(id);
            return;
        }
    }
}
