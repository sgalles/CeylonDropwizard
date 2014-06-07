import com.yammer.dropwizard {...}
import com.yammer.dropwizard.config { ... }
import com.fasterxml.jackson.annotation {jsonProperty}
import org.hibernate.validator.constraints {notEmpty}
import java.lang { JavaString = String , ObjectArray}
import java.util.concurrent.atomic { ... }
import javax.ws.rs { get = gET, ... }
import com.google.common.base { Optional }
import com.yammer.metrics.core { HealthCheck }
import com.yammer.metrics.annotation { timed }


shared class HelloWorldConfiguration() extends Configuration(){
    
    notEmpty
    jsonProperty 
    shared JavaString? template = null;
    
    notEmpty
    jsonProperty
    shared JavaString defaultName = JavaString("Stranger");
    
}


shared class HelloWorldService() extends Service2<HelloWorldConfiguration>(){

	shared actual void initialize(Bootstrap<HelloWorldConfiguration> bootstrap) {
		bootstrap.name = "hello-world";
	}

	shared actual void run(HelloWorldConfiguration configuration, Environment environment) {
		 assert(exists template = configuration.template);
    	 environment.addResource(HelloWorldResource(template, configuration.defaultName));
    	 environment.addHealthCheck(TemplateHealthCheck(template.string));
	}
}

shared class Saying(shared Integer id, shared String content){}
 

path("/hello-world")   
produces({ "application/json"})
shared class  HelloWorldResource(JavaString template, JavaString defaultName){
 	AtomicLong counter = AtomicLong();
 	
 	get
 	timed
 	shared Saying sayHello(queryParam("name") Optional<JavaString> name) {
 		return Saying(counter.incrementAndGet(), JavaString.format(template.string,name.or(defaultName).string));
 	}
 	
 }
  
  
  shared class  TemplateHealthCheck(String template) extends HealthCheck("template"){

      shared actual HealthCheck.Result check() {
            value saying = JavaString.format(template, "TEST");
            if (!saying.contains("TEST")) {
                return Result.unhealthy("template doesn't include a name");
            }
            return Result.healthy();
      }
     
  }
  
   shared void run(){
     ObjectArray<JavaString> array = ObjectArray<JavaString>(2);
     array.set(0, JavaString("server"));
     array.set(1, JavaString("hello-world.yml"));
     HelloWorldService().run2(array);    
    }
 
 
 
 