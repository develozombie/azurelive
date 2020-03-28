using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Text;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Azure.ServiceBus;

namespace Clase3.Function
{
    public static class Enviar
    {
        const string ServiceBusConnectionString = "";
        const string QueueName = "clientes";
        static IQueueClient queueClient;

        [FunctionName("Enviar")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            string name = req.Query["name"];
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            name = name ?? data?.name;
            log.LogInformation("C# HTTP trigger function processed a request.");
            if(!String.IsNullOrEmpty(name))
            {
                queueClient = new QueueClient(ServiceBusConnectionString, QueueName);
                await SendMessagesAsync(name, log);
                return new OkObjectResult($"{DateTime.Now} :: Mensaje: {name}");
            }
            return new OkObjectResult($"{DateTime.Now} :: Esperando mensaje");
            
        }

        static async Task SendMessagesAsync(string value, ILogger log)
        {
            try
            {
                // Create a new message to send to the queue.
                string messageBody = value;
                var message = new Message(Encoding.UTF8.GetBytes(messageBody));

                // Write the body of the message to the console.
                log.LogInformation($"Sending message: {messageBody}");

                // Send the message to the queue.
                await queueClient.SendAsync(message);
            }
            catch (Exception exception)
            {
                log.LogInformation($"{DateTime.Now} :: Exception: {exception.Message}");
            }
        }    }
}
