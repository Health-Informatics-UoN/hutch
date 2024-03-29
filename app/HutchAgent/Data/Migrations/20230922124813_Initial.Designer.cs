﻿// <auto-generated />
using System;
using HutchAgent.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace HutchAgent.Migrations
{
    [DbContext(typeof(HutchAgentContext))]
    [Migration("20230922124813_Initial")]
    partial class Initial
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder.HasAnnotation("ProductVersion", "7.0.10");

            modelBuilder.Entity("HutchAgent.Data.Entities.WorkflowJob", b =>
                {
                    b.Property<string>("Id")
                        .HasColumnType("TEXT");

                    b.Property<string>("CrateSource")
                        .HasColumnType("TEXT");

                    b.Property<string>("DataAccess")
                        .HasColumnType("TEXT");

                    b.Property<string>("EgressTarget")
                        .HasColumnType("TEXT");

                    b.Property<DateTimeOffset?>("EndTime")
                        .HasColumnType("TEXT");

                    b.Property<DateTimeOffset?>("ExecutionStartTime")
                        .HasColumnType("TEXT");

                    b.Property<string>("ExecutorRunId")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<int?>("ExitCode")
                        .HasColumnType("INTEGER");

                    b.Property<string>("WorkingDirectory")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.HasKey("Id");

                    b.ToTable("WorkflowJobs");
                });
#pragma warning restore 612, 618
        }
    }
}
