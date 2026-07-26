use anyhow::Result;
use clap::Parser;
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::PathBuf;

#[derive(Parser)]
struct Args {
    #[arg(short, long)]
    config: PathBuf,

    #[arg(short, long)]
    output: PathBuf,
}

#[derive(Debug, Deserialize)]
struct Config {
    rules: Vec<ConfigRule>,
}

#[derive(Debug, Deserialize)]
struct ConfigRule {
    initiator: String,
    exclude: Vec<String>,
}

#[derive(Debug, Serialize)]
struct Rule {
    id: u32,
    priority: u32,
    action: Action,
    condition: Condition,
}

#[derive(Debug, Serialize)]
struct Action {
    #[serde(rename = "type")]
    action_type: String,
}

#[derive(Debug, Serialize)]
struct Condition {
    #[serde(rename = "urlFilter")]
    url_filter: String,

    #[serde(rename = "resourceTypes")]
    resource_types: Vec<String>,

    #[serde(rename = "initiatorDomains")]
    initiator_domains: Vec<String>,
}


fn main() -> Result<()> {
    let args = Args::parse();

    let yaml = fs::read_to_string(&args.config)?;

    let config: Config = serde_yaml::from_str(&yaml)?;

    let mut rules = Vec::new();

    let mut id = 1;

    for entry in config.rules {
        for filter in entry.exclude {
            rules.push(Rule {
                id,
                priority: 1,

                action: Action {
                    action_type: "block".into(),
                },

                condition: Condition {
                    url_filter: filter,

                    resource_types: vec![
                        "script".into()
                    ],

                    initiator_domains: vec![
                        entry.initiator.clone()
                    ],
                },
            });

            id += 1;
        }
    }

    fs::create_dir_all(&args.output)?;

    let output_file = args.output.join("rules.json");

    let json = serde_json::to_string_pretty(&rules)?;

    fs::write(&output_file, json)?;

    println!(
        "Generated {} rules into {}",
        rules.len(),
        output_file.display()
    );

    Ok(())
}