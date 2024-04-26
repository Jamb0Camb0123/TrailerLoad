using System;
using System.Linq;
using System.Web;
using System.Collections.Generic;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Data;

namespace Morningfoods.Modules.HJLeaTrailerLoad
{
    public class TaskController
    {
        public IList<Task> GetTasks(int ModuleID, string trlr_id)
        {
            return CBO.FillCollection<Task>(DataProvider.Instance().ExecuteReader("HJLeaTrailerLoad_GetTasks", ModuleID, trlr_id));
        }

        public void AddTask(Task task)
        {
            task.ld_id = DataProvider.Instance().ExecuteScalar<int>("HJLeaTrailerLoad_AddTask",
                                                      task.trlr_id,
                                                      task.lded_wth,
                                                      task.lded_dte,
                                                      task.lded_site,
                                                      task.ModuleID,
                                                      task.UserID
                                                        );
        }
    }
}