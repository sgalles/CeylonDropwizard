package drop;

import com.yammer.dropwizard.Service;
import com.yammer.dropwizard.config.Bootstrap;
import com.yammer.dropwizard.config.Configuration;
import com.yammer.dropwizard.config.Environment;

public abstract class Service2<T extends Configuration> extends Service<T> {

	@Override
	public abstract void initialize(Bootstrap<T> arg0);

	public void run2(String[] args ) throws Exception {
		run(args);
	}

}
