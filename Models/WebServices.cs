using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Users;
using DotNetNuke.Security;
using DotNetNuke.Web.Api;
using DotNetNuke.Web.Services;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Morningfoods.Modules.HJLeaTrailerLoad.Models
{
    public class ModuleTaskController : DnnApiController
    {

        [AllowAnonymous]
        [HttpGet]
        public HttpResponseMessage GetTasks(int moduleID, string trlr_id)
        {
            try
            {
                var tasks = new TaskController().GetTasks(moduleID, trlr_id).ToJson();
                return Request.CreateResponse(HttpStatusCode.OK, tasks);
            }
            catch (Exception exc)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, exc);
            }
        }

        public class TaskToCreateDTO
        {
            public string TTC_trlr_id { get; set; }
            public string TTC_lded_wth { get; set; }
            public string TTC_lded_dte { get; set; }
            public string TTC_lded_site { get; set; }
            public int TTC_ModuleID { get; set; }
            public int TTC_UserId { get; set; }
        }

        [AllowAnonymous]
        [HttpPost]
        public HttpResponseMessage AddTask(TaskToCreateDTO DTO)
        {
            try
            {
                var task = new Task()
                {
                    trlr_id = DTO.TTC_trlr_id,
                    lded_wth = DTO.TTC_lded_wth,
                    lded_dte = DTO.TTC_lded_dte,
                    lded_site = DTO.TTC_lded_site,
                    ModuleID = DTO.TTC_ModuleID,
                    UserID = DTO.TTC_UserId
                };
                TaskController tc = new TaskController();
                tc.AddTask(task);
                return Request.CreateResponse(HttpStatusCode.OK);
            }
            catch (Exception exc)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, exc);
            }
        }
    }
}