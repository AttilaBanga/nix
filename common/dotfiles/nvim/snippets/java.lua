local return_filename = function()
    return vim.fn.fnamemodify(vim.fn.expand('%'),':t:r')
end

local return_tested_class_name = function()
    return vim.fn.fnamemodify(vim.fn.expand('%'),':t:r'):gsub("Test", "")
end

local return_package = function()
    return vim.fn.fnamemodify(vim.fn.expand('%'),':.:h'):gsub("src/main/java/", ""):gsub("/", ".")
end

local return_test_package = function()
    return vim.fn.fnamemodify(vim.fn.expand('%'),':.:h'):gsub("src/test/java/", ""):gsub("/", ".")
end

local return_table_name = function()
    return return_filename():gsub('%f[^%l]%u','_%1'):gsub('%f[^%a]%d','_%1'):gsub('%f[^%d]%a','_%1'):gsub('(%u)(%u%l)','%1_%2'):lower()
end

return {
	s("repository", fmt([[
    package {package_name};

    import org.springframework.data.r2dbc.repository.R2dbcRepository;
    import org.springframework.stereotype.Repository;

    import reactor.core.publisher.Flux;
    import reactor.core.publisher.Mono;

    @Repository
    public interface {object_name} extends R2dbcRepository<{entity}, Long> {{

    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
        entity = i(1)
    })),

	s("contoller", fmt([[
    package {package_name};

    import java.security.Principal;

    import org.springframework.web.bind.annotation.DeleteMapping;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.PatchMapping;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.PostMapping;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.ResponseStatus;
    import org.springframework.web.bind.annotation.RestController;

    import lombok.RequiredArgsConstructor;
    import reactor.core.publisher.Mono;
    import reactor.core.publisher.Flux;

    @RequiredArgsConstructor
    @RequestMapping("{path}")
    @RestController
    public class {object_name} {{

    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
        path = i(1),
    })),

	s("service", fmt([[
    package {package_name};

    import org.springframework.stereotype.Service;

    import lombok.RequiredArgsConstructor;
    import reactor.core.publisher.Flux;
    import reactor.core.publisher.Mono;

    @Service
    @RequiredArgsConstructor
    public class {object_name} implements I{object_name} {{

    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
    })),
	s("model", fmt([[
    package {package_name};

    import lombok.Builder;
    import lombok.Data;
    import lombok.With;

    import java.time.LocalDateTime;

    import org.springframework.data.annotation.Id;
    import org.springframework.data.relational.core.mapping.Column;
    import org.springframework.data.relational.core.mapping.Table;

    @With
    @Data
    @Builder(toBuilder = true)
    @Table("{table_name}")
    public class {object_name} {{

        @Id
        Long id;

        LocalDateTime createdAt;

        LocalDateTime updatedAt;

        LocalDateTime deletedAt;

    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
        table_name = f(return_table_name, {}),
    })),

	s("test", c(1, {
    fmt([[
    package {package_name};

    import org.assertj.core.api.Assertions;
    import org.assertj.core.api.InstanceOfAssertFactories;
    import org.assertj.core.api.ObjectAssert;
    import org.hamcrest.Matchers;
    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.autoconfigure.web.reactive.AutoConfigureWebTestClient;
    import org.springframework.boot.test.context.SpringBootTest;
    import org.springframework.security.test.context.support.WithMockUser;
    import org.springframework.test.web.reactive.server.WebTestClient;

    import reactor.test.StepVerifier;

    @AutoConfigureWebTestClient
    @SpringBootTest
    public class {object_name} {{
        
        @Autowired
        WebTestClient webTestClient;

        {}
    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_test_package, {}),
        i(1),
    }),
    fmt([[
    package {package_name};

    import org.assertj.core.api.Assertions;
    import org.assertj.core.api.InstanceOfAssertFactories;
    import org.assertj.core.api.ObjectAssert;
    import org.hamcrest.Matchers;
    import org.junit.jupiter.api.Test;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.autoconfigure.data.r2dbc.DataR2dbcTest;
    import {package_name}.{tested_class_name};

    import reactor.test.StepVerifier;

    @DataR2dbcTest
    public class {object_name} {{
        
        @Autowired
        {tested_class_name} repository;
        {}
    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_test_package, {}),
        tested_class_name = f(return_tested_class_name, {}),
        i(1),
    }),

    fmt([[
    package {package_name};

    import org.assertj.core.api.Assertions;
    import org.assertj.core.api.InstanceOfAssertFactories;
    import org.assertj.core.api.ObjectAssert;
    import org.junit.jupiter.api.Test;
    import org.mockito.Mockito;
    import org.mockito.junit.jupiter.MockitoSettings;
    import org.mockito.InjectMocks;

    @MockitoSettings
    public class {object_name} {{
        @InjectMocks        
        {}
    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_test_package, {}),
        i(1),
    }),

    })),

    s("class", fmt([[
    package {package_name};

    public class {object_name} {{

        {}
    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
        i(1),
    })),

    s("interface", fmt([[
    package {package_name};

    public interface {object_name} {{

        {}
    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
        i(1),
    })),

    s("enum", fmt([[
    package {package_name};

    public enum {object_name} {{

        {}
    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
        i(1),
    })),

    s("dto", fmt([[
    package {package_name};

    import lombok.Builder;
    import lombok.Value;
    import lombok.With;
    import lombok.extern.jackson.Jacksonized;

    import java.time.LocalDateTime;

    @Jacksonized
    @Builder(toBuilder = true)
    @With
    @Value
    public class {object_name} {{

        {}
    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
        i(1),
    })),

    s("mapper", fmt([[
    package {package_name};

    import org.mapstruct.InjectionStrategy;
    import org.mapstruct.Mapper;

    @Mapper(componentModel = "spring", injectionStrategy = InjectionStrategy.CONSTRUCTOR)
    public interface {object_name} {{

        {}
    }}
    ]], {
        object_name = f(return_filename, {}),
        package_name = f(return_package, {}),
        i(1),
    })),

}
