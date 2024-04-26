using System;
using DotNetNuke.Web.Api;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Morningfoods.Modules.HJLeaTrailerLoad.Models
{
    public class RouteMapper : IServiceRouteMapper
    {
        public void RegisterRoutes(IMapRoute mapRouteManager)
        {
            mapRouteManager.MapHttpRoute(
                moduleFolderName: "HJLeaTrailerLoad",
                routeName:"default",
                url:"{controller}/{action}",
                namespaces: new[] { "Morningfoods.Modules.HJLeaTrailerLoad.Models" }
                );

            mapRouteManager.MapHttpRoute(
                moduleFolderName: "HJLeaTrailerLoad",
                routeName: "GetTasks",
                url: "{controller}/{action}/{ModuleID}/{trlr_id}",
                namespaces: new[] { "Morningfoods.Modules.HJLeaTrailerLoad.Models" }
            );
        }
    }
}