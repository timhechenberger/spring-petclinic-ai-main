package org.springframework.samples.petclinic.rest.dto;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonTypeName;
import org.springframework.lang.Nullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import org.hibernate.validator.constraints.*;
import io.swagger.v3.oas.annotations.media.Schema;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * A role.
 */

@Schema(name = "Role", description = "A role.")
@JsonTypeName("Role")
<<<<<<< HEAD
@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2026-03-13T07:39:41.412254200+01:00[Europe/Vienna]", comments = "Generator version: 7.18.0")
=======
@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", date = "2026-03-06T09:15:59.842962+01:00[Europe/Berlin]", comments = "Generator version: 7.18.0")
>>>>>>> fcff6641011eb27f4e5e04fff16448a45efb5794
public class RoleDto {

  private String name;

  public RoleDto() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public RoleDto(String name) {
    this.name = name;
  }

  public RoleDto name(String name) {
    this.name = name;
    return this;
  }

  /**
   * The role's name
   * @return name
   */
  @NotNull @Size(min = 1, max = 80) 
  @Schema(name = "name", example = "admin", description = "The role's name", requiredMode = Schema.RequiredMode.REQUIRED)
  @JsonProperty("name")
  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    RoleDto role = (RoleDto) o;
    return Objects.equals(this.name, role.name);
  }

  @Override
  public int hashCode() {
    return Objects.hash(name);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class RoleDto {\n");
    sb.append("    name: ").append(toIndentedString(name)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}

